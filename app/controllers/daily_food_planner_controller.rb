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
      @results[:prots] = selectedIngredient.prots * Integer(params['quantity0'])
      @results[:carbs] = selectedIngredient.carbs * Integer(params['quantity0'])
      @results[:fats] = selectedIngredient.fats * Integer(params['quantity0'])
      @results[:cals] = selectedIngredient.cals * Integer(params['quantity0'])
      @meals << [params['ingredient0'], params['quantity0']]
    end

    if params['commit'] == 'Submit' and not params['ingredient1'] == '0'

      selectedIngredient = Ingredient.where(name: params['ingredient1']).first
      @results[:prots] += selectedIngredient.prots * Integer(params['quantity1'])
      @results[:carbs] += selectedIngredient.carbs * Integer(params['quantity1'])
      @results[:fats] += selectedIngredient.fats * Integer(params['quantity1'])
      @results[:cals] += selectedIngredient.cals * Integer(params['quantity1'])
      @meals << [params['ingredient1'], params['quantity1']]
    end
  end

  def list
  end

end
