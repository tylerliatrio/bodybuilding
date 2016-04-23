class DailyFoodPlannerController < ApplicationController

  def is_number?(string)
    true if Float(string) rescue false
  end

  def enter
    flash['entry'] = false

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
    @names = Hash.new
    @quantities = Hash.new

    if params['commit'] == 'Submit'
      @meals = Array.new
      @totals = Hash.new
      @target = Hash.new
      @weight = Float(params['weight']) unless params['weight'].blank?
      flash['error'] = nil
      @totals[:prots] = 0
      @totals[:carbs] = 0
      @totals[:fats] = 0
      @totals[:cals] = 0

      # targets
      if not (params['target_prots'].blank? or
          params['target_carbs'].blank? or
          params['target_fats'].blank? or
          params['weight'].blank? or flash['error'])

        @target_prots_per_kilo = Float(params['target_prots'])
        @target_carbs_per_kilo = Float(params['target_carbs'])
        @target_fats_per_kilo = Float(params['target_fats'])

        kiloWeight = @weight/2.20462

        @target[:prots] = (kiloWeight * @target_prots_per_kilo).round(0)
        @target[:carbs] = (kiloWeight * @target_carbs_per_kilo).round(0)
        @target[:fats] = (kiloWeight * @target_fats_per_kilo).round(0)

      else
        flash['error'] = 'Please enter your weight and select your body type!' if params['body_type'].blank? or params['weight'].blank?
      end

      # getting quantities
      for i in 0..9
        ingredient_name = params['ingredient'+ String(i)]

        unless ingredient_name == '0'
          quantity = params['quantity' + String(i)]
          @names[i] = ingredient_name

          if quantity.blank?
            flash['error'] = 'Please enter quantity for '+ @names[i]
          else

            if is_number?(quantity)
              @quantities[i] = Float(quantity)
            else
              flash['error'] = 'Error: Quantity can be only a number!'
            end

          end
        end

        # calculate if no errors
        unless flash['error']
          unless ingredient_name == '0'
            selectedIngredient = Ingredient.where(name: @names[i]).first
            @totals[:prots] += selectedIngredient.prots * @quantities[i] / selectedIngredient.serving_size
            @totals[:carbs] += selectedIngredient.carbs * @quantities[i] / selectedIngredient.serving_size
            @totals[:fats] += selectedIngredient.fats * @quantities[i] / selectedIngredient.serving_size
            @totals[:cals] += selectedIngredient.cals * @quantities[i] / selectedIngredient.serving_size
            @meals << [ingredient_name, quantity, selectedIngredient.units]
          end
        end

      end
    end
  end

  def list
  end
end
