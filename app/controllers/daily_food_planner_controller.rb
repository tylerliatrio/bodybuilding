class DailyFoodPlannerController < ApplicationController

  def is_number?(string)
    true if Float(string) rescue false
  end

  def enter
    flash['entry'] = false
    flash['message'] = false

    if not params['name'].blank?

      flash['message'] = nil

      Ingredient.create(name: params['name'], units: params['units'], serving_size: params['serving_size'],
                        prots: Integer(params['prots']), carbs: Integer(params['carbs']), fats: Integer(params['fats']),
                        cals: Integer(params['cals']))
      flash['entry'] = true
    else

      if not params['commit'].blank?
        if params['commit'] == 'Delete last entry' and Ingredient.count > 0
          flash['message'] = 'Removed ' + Ingredient.last.name + '!'
          Ingredient.last.destroy
        else
          flash['message'] = 'Nothing to remove. Database is empty.'
        end

        if params['commit'] == 'DB reset'
          flash['message'] = 'Database is reset!'
          Ingredient.destroy_all if Ingredient.count > 0
        end
      end
    end
  end

  def plan
    flash['entry'] = false
    flash[:errors] = []
    flash['message'] = false

    @names = Hash.new
    @quantities = Hash.new

    if params['commit'] == 'Submit'
      @meals = Array.new
      @totals = Hash.new
      @target = Hash.new

      @totals[:prots] = 0
      @totals[:carbs] = 0
      @totals[:fats] = 0
      @totals[:cals] = 0

      if params['weight'].blank?
        flash[:errors] << 'Error: Please enter your body weight.'
      else
        @weight = Float(params['weight'])
        kiloWeight = @weight/2.20462
      end

      if params['target_prots_per_kilo'].blank?
        flash[:errors] << 'Error: Enter your Protein target.'
      else
        @target_prots_per_kilo = Float(params['target_prots_per_kilo'])
      end

      if params['target_carbs_per_kilo'].blank?
        flash[:errors] << 'Error: Enter your Carbs target.'
      else
        @target_carbs_per_kilo = Float(params['target_carbs_per_kilo'])
      end

      if params['target_fats_per_kilo'].blank?
        flash[:errors] << 'Error: Enter your Fats target.'
      else
        @target_fats_per_kilo = Float(params['target_fats_per_kilo'])
      end


      if @target_carbs_per_kilo and @target_fats_per_kilo and @target_prots_per_kilo
        @target[:prots] = (kiloWeight * @target_prots_per_kilo).round(0)
        @target[:carbs] = (kiloWeight * @target_carbs_per_kilo).round(0)
        @target[:fats] = (kiloWeight * @target_fats_per_kilo).round(0)
      end

      flash[:errors] << 'Error: Select at least one ingredient.' if params['ingredient0'] == '0'

      # getting quantities
      for i in 0..9

        ingredient_name = params['ingredient'+ String(i)]

        if ingredient_name == '0'

        else
          quantity = params['quantity' + String(i)]
          @names[i] = ingredient_name

          if quantity.blank?
            flash[:errors] << 'Error: Please enter quantity for ' + @names[i]
          else

            if is_number?(quantity)
              @quantities[i] = Float(quantity)

              selectedIngredient = Ingredient.where(name: @names[i]).first
              @totals[:prots] += selectedIngredient.prots * @quantities[i] / selectedIngredient.serving_size
              @totals[:carbs] += selectedIngredient.carbs * @quantities[i] / selectedIngredient.serving_size
              @totals[:fats] += selectedIngredient.fats * @quantities[i] / selectedIngredient.serving_size
              @totals[:cals] += selectedIngredient.cals * @quantities[i] / selectedIngredient.serving_size

              @totals[:prots] = @totals[:prots].round(0)
              @totals[:carbs] = @totals[:carbs].round(0)
              @totals[:fats] = @totals[:fats].round(0)
              @totals[:cals] = @totals[:cals].round(0)

              @meals << [ingredient_name, quantity, selectedIngredient.units]
              flash['message'] = 'Success! Scroll down to see the results.'
              flash[:errors] = nil

            else
              flash[:errors] << 'Error: Quantity can be only a number.'
            end

          end
        end

      end
    end
  end

  def list
    flash['entry'] = false
    flash['message'] = false
  end
end
