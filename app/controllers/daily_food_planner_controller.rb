class DailyFoodPlannerController < ApplicationController
  def enter
    flash['entry'] = false

    if not params['name'].blank?

      flash['message'] = nil

      Ingredient.create(name: params['name'], serving_type: params['serving_type'], serving_size: params['serving_size'],
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
    @results = Hash.new if @results.nil?

    @meals = Array.new

    if params['commit'] == 'Submit' and not params['ingredient0'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient0']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] = selectedIngredient.prots * Integer(params['quantity0'])/selectedIngredient.serving_size
        @results[:carbs] = selectedIngredient.carbs * Integer(params['quantity0'])/selectedIngredient.serving_size
        @results[:fats] = selectedIngredient.fats * Integer(params['quantity0'])/selectedIngredient.serving_size
        @results[:cals] = selectedIngredient.cals * Integer(params['quantity0'])/selectedIngredient.serving_size
      else
        @results[:prots] = selectedIngredient.prots * Integer(params['quantity0'])
        @results[:carbs] = selectedIngredient.carbs * Integer(params['quantity0'])
        @results[:fats] = selectedIngredient.fats * Integer(params['quantity0'])
        @results[:cals] = selectedIngredient.cals * Integer(params['quantity0'])
      end

      @meals << [params['ingredient0'], params['quantity0'], selectedIngredient.serving_type]
    end

    if params['commit'] == 'Submit' and not params['ingredient1'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient1']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity1'])/selectedIngredient.serving_size
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity1'])/selectedIngredient.serving_size
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity1'])/selectedIngredient.serving_size
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity1'])/selectedIngredient.serving_size
      else
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity1'])
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity1'])
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity1'])
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity1'])
      end

      @meals << [params['ingredient1'], params['quantity1'], selectedIngredient.serving_type]
    end

    if params['commit'] == 'Submit' and not params['ingredient2'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient2']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity2'])/selectedIngredient.serving_size
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity2'])/selectedIngredient.serving_size
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity2'])/selectedIngredient.serving_size
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity2'])/selectedIngredient.serving_size
      else
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity2'])
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity2'])
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity2'])
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity2'])
      end

      @meals << [params['ingredient2'], params['quantity2'], selectedIngredient.serving_type]
    end

    if params['commit'] == 'Submit' and not params['ingredient3'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient3']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity3'])/selectedIngredient.serving_size
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity3'])/selectedIngredient.serving_size
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity3'])/selectedIngredient.serving_size
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity3'])/selectedIngredient.serving_size
      else
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity3'])
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity3'])
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity3'])
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity3'])
      end

      @meals << [params['ingredient3'], params['quantity3'], selectedIngredient.serving_type]
    end

    if params['commit'] == 'Submit' and not params['ingredient4'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient4']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity4'])/selectedIngredient.serving_size
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity4'])/selectedIngredient.serving_size
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity4'])/selectedIngredient.serving_size
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity4'])/selectedIngredient.serving_size
      else
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity4'])
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity4'])
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity4'])
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity4'])
      end

      @meals << [params['ingredient4'], params['quantity4'], selectedIngredient.serving_type]
    end

    if params['commit'] == 'Submit' and not params['ingredient5'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient5']).first

      if selectedIngredient.serving_type == 'ml' or selectedIngredient.serving_type == 'g'
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity5'])/selectedIngredient.serving_size
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity5'])/selectedIngredient.serving_size
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity5'])/selectedIngredient.serving_size
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity5'])/selectedIngredient.serving_size
      else
        @results[:prots] += selectedIngredient.prots * Integer(params['quantity5'])
        @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity5'])
        @results[:fats] += selectedIngredient.fats * Integer(params['quantity5'])
        @results[:cals] += selectedIngredient.cals * Integer(params['quantity5'])
      end

      @meals << [params['ingredient5'], params['quantity5'], selectedIngredient.serving_type]
    end

  end

  def list
  end

end
