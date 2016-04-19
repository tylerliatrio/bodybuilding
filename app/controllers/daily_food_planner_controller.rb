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

    if params['commit'] == 'Submit'
      @meals = Array.new
      @totals = Hash.new

      flash['error'] = nil

      @totals[:prots] = 0
      @totals[:carbs] = 0
      @totals[:fats] = 0
      @totals[:cals] = 0

      @target = Hash.new
      @weight = Float(params['weight']) unless params['weight'].blank?

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
      unless params['ingredient0'] == '0'
        @name0 = params['ingredient0']

        if params['quantity0'].blank?
          flash['error'] = 'Please enter quantity for '+ @name0
        else

          if is_number?(params['quantity0'])
            @quantity0 = Float(params['quantity0'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end

        end
      end

      unless params['ingredient1'] == '0'
        @name1 = params['ingredient1']

        if params['quantity1'].blank?
          flash['error'] = 'Please enter quantity for '+ @name1
        else
          if is_number?(params['quantity1'])
            @quantity1 = Float(params['quantity1'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end
        end
      end

      unless params['ingredient2'] == '0'
        @name2 = params['ingredient2']

        if params['quantity2'].blank?
          flash['error'] = 'Please enter quantity for '+ @name2
        else
          if is_number?(params['quantity2'])
            @quantity2 = Float(params['quantity2'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end
        end
      end

      unless params['ingredient3'] == '0'
        @name3 = params['ingredient3']

        if params['quantity3'].blank?
          flash['error'] = 'Please enter quantity for '+ @name3
        else
          if is_number?(params['quantity3'])
            @quantity3 = Float(params['quantity3'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end
        end
      end

      unless params['ingredient4'] == '0'
        @name4 = params['ingredient4']

        if params['quantity4'].blank?
          flash['error'] = 'Please enter quantity for '+ @name4
        else
          if is_number?(params['quantity4'])
            @quantity4 = Float(params['quantity4'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end
        end
      end

      unless params['ingredient5'] == '0'
        @name5 = params['ingredient5']

        if params['quantity5'].blank?
          flash['error'] = 'Please enter quantity for '+ @name5
        else
          if is_number?(params['quantity5'])
            @quantity5 = Float(params['quantity5'])
          else
            flash['error'] = 'Error: Quantity can be only a number!'
          end
        end
      end


      # calculate if no errors
      unless flash['error']
        unless params['ingredient0'] == '0'
          selectedIngredient = Ingredient.where(name: @name0).first
          @totals[:prots] += selectedIngredient.prots * @quantity0 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity0 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity0 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity0 / selectedIngredient.serving_size
          @meals << [params['ingredient0'], params['quantity0'], selectedIngredient.units]
        end

        unless params['ingredient1'] == '0'
          selectedIngredient = Ingredient.where(name: @name1).first
          @totals[:prots] += selectedIngredient.prots * @quantity1 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity1 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity1 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity1 / selectedIngredient.serving_size
          @meals << [params['ingredient1'], params['quantity1'], selectedIngredient.units]
        end

        unless params['ingredient2'] == '0'
          selectedIngredient = Ingredient.where(name: @name2).first
          @totals[:prots] += selectedIngredient.prots * @quantity2 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity2 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity2 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity2 / selectedIngredient.serving_size
          @meals << [params['ingredient2'], params['quantity2'], selectedIngredient.units]
        end

        unless params['ingredient3'] == '0'
          selectedIngredient = Ingredient.where(name: @name3).first
          @totals[:prots] += selectedIngredient.prots * @quantity3 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity3 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity3 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity3 / selectedIngredient.serving_size
          @meals << [params['ingredient3'], params['quantity3'], selectedIngredient.units]
        end

        unless params['ingredient4'] == '0'
          selectedIngredient = Ingredient.where(name: @name4).first
          @totals[:prots] += selectedIngredient.prots * @quantity4 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity4 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity4 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity4 / selectedIngredient.serving_size
          @meals << [params['ingredient4'], params['quantity4'], selectedIngredient.units]
        end

        unless params['ingredient5'] == '0'
          selectedIngredient = Ingredient.where(name: @name5).first
          @totals[:prots] += selectedIngredient.prots * @quantity5 / selectedIngredient.serving_size
          @totals[:carbs] += selectedIngredient.carbs * @quantity5 / selectedIngredient.serving_size
          @totals[:fats] += selectedIngredient.fats * @quantity5 / selectedIngredient.serving_size
          @totals[:cals] += selectedIngredient.cals * @quantity5 / selectedIngredient.serving_size
          @meals << [params['ingredient5'], params['quantity5'], selectedIngredient.units]
        end
      end
    end
  end

  def list
  end
end
