class LinksController < ApplicationController
	before_action :authenticate_current_user!

	def index
		links = Link.where(:group_id => params[:group_id]).order(created_at: :desc).paginate(:page => params[:page])
		@days = links.group_by { |t| t.created_at.beginning_of_day }

		respond_to do |format|
			format.html  { render layout: false }
			format.json { render json: @days.to_json(:include => :user) }
     	end
		
	end
end