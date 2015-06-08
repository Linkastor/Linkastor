class LinksController < ApplicationController
	before_action :authenticate_current_user!

	def index
		links = Link.where(:group_id => params[:group_id])
		@days = links.group_by { |t| t.created_at.beginning_of_day }

		render layout: false
	end
end