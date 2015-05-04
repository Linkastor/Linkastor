class LinksController < ApplicationController
	before_action :authenticate_current_user!

	def index
		@links = Link.where(:group_id => params[:group_id])

		render layout: false
	end
end