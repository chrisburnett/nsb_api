class Api::V1::SorCodesController < ApplicationController

  # note - puts a lot of load on the database. Would be better to use
  # redis for this kind of thing, and other key searches
  def index
    if(params[:term])
      render json: Item
               .where("sor_code ILIKE ?", "%#{params[:term]}%")
               .distinct
               .map { |i| i.sor_code }
    else
      head :uprocessable_entity
    end
  end

end
