class DailyFoodPlannerController < ApplicationController

  def is_number?(string)
    true if Float(string) rescue false
  end

  def enter
    flash[:errors] = []
    flash[:message] = false

    if params['commit'] == 'Submit'

      if params['title'].blank?
        flash[:errors] << 'Please enter Ingredient Title'
      else
        @title = params['title']
      end

      if params['units'].blank?
        flash[:errors] << 'Please enter Units'
      else
        @units = params['units']
      end

      if params['serving_size'].blank?
        flash[:errors] << 'Please enter Serving Size'
      else
        @serving_size = params['serving_size']
      end

      if params['prots'].blank?
        flash[:errors] << 'Please enter Protein per serving'
      else
        @prots = params['prots']
      end

      if params['carbs'].blank?
        flash[:errors] << 'Please enter Carbs per serving'
      else
        @carbs = params['carbs']
      end

      if params['fats'].blank?
        flash[:errors] << 'Please enter Fats per serving'
      else
        @fats = params['fats']
      end

      if params['cals'].blank?
        flash[:errors] << 'Please enter Calories per serving'
      else
        @cals = params['cals']
      end

      if params['sugar'].blank?
        flash[:errors] << 'Please grams of Sugar per serving'
      else
        @sugar = params['sugar']
      end

      if flash[:errors].blank?
        Ingredient.create(name: params['title'], units: params['units'], serving_size: params['serving_size'],
                          prots: Integer(@prots), carbs: Integer(@carbs), fats: Float(@fats), cals: Integer(@cals),
                          sugar: @sugar)
        @added_item = true
      end

    end
  end

  def plan

    gon.ingredients = Ingredient.all

    @ingredients = Array.new
    @ingredients << Ingredient.where("prots > ?", 0).order('name ASC')
    @ingredients << Ingredient.where("carbs > ? AND prots < ?", 10, 15).order('name ASC')
    @ingredients << Ingredient.where("fats > ?", 10).order('name ASC')

    flash[:errors] = []
    flash[:message] = false

    @ingredient_name = Hash.new
    @quantities = Hash.new

    if params['commit'] == 'Verify'

      if params['weight'].blank?
        flash[:errors] << ' Please enter your body weight.'
      else
        @weight = Float(params['weight'])
        kiloWeight = @weight/2.20462
      end


      if params['target_presets'].blank?

      else
        @target_presets = params['target_presets']
      end

      if params['target_prots_per_kilo'].blank?
        flash[:errors] << ' Enter your Protein target.'
      else
        @target_prots_per_kilo = Float(params['target_prots_per_kilo'])
      end

      if params['target_carbs_per_kilo'].blank?
        flash[:errors] << ' Enter your Carbs target.'
      else
        @target_carbs_per_kilo = Float(params['target_carbs_per_kilo'])
      end

      if params['target_fats_per_kilo'].blank?
        flash[:errors] << ' Enter your Fats target.'
      else
        @target_fats_per_kilo = Float(params['target_fats_per_kilo'])
      end

      if @target_carbs_per_kilo and @target_fats_per_kilo and @target_prots_per_kilo and @weight
        @target = Hash.new
        @target[:prots] = (kiloWeight * @target_prots_per_kilo).round(0)
        @target[:carbs] = (kiloWeight * @target_carbs_per_kilo).round(0)
        @target[:fats] = (kiloWeight * @target_fats_per_kilo).round(0)
      end

      # getting quantities for ingredients
      for i in 0..8
        ingredient_name = params['ingredient'+ String(i)]
        if ingredient_name == '0'

        else
          quantity = params['quantity' + String(i)]
          @ingredient_name[i] = ingredient_name
          if quantity.blank?
            flash[:errors] << ' Please enter quantity for ' + @ingredient_name[i]
          else
            if is_number?(quantity)
              @quantities[i] = Float(quantity)
            else
              flash[:errors] << ' Quantity can be only a number.'
            end

          end
        end
      end

      if flash[:errors].blank?
        @totals = Hash.new
        @totals[:prots] = 0
        @totals[:carbs] = 0
        @totals[:fats] = 0
        @totals[:cals] = 0
        @totals[:sugar] = 0

        for i in 0..8
          unless @ingredient_name[i].blank?
            selectedIngredient = Ingredient.where(name: @ingredient_name[i]).first
            @totals[:prots] += selectedIngredient.prots * @quantities[i] / selectedIngredient.serving_size
            @totals[:carbs] += selectedIngredient.carbs * @quantities[i] / selectedIngredient.serving_size
            @totals[:fats] += selectedIngredient.fats * @quantities[i] / selectedIngredient.serving_size
            @totals[:cals] += selectedIngredient.cals * @quantities[i] / selectedIngredient.serving_size
            @totals[:sugar] += selectedIngredient.sugar * @quantities[i] / selectedIngredient.serving_size
          end
        end

        flash[:message] = 'Success! Scroll down to see the results.'
        flash[:errors] = []
      end
    end
  end

  def list
    flash[:message] = false
    flash[:errors] = []
  end
end
