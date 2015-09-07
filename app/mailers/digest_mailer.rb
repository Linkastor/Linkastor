class DigestMailer < ApplicationMailer
  def send_digest(user:)
    @link_presenter = LinkPresenter.new
    @user = user
    @groups = user.groups
    @custom_sources = @user.admin ? @user.custom_sources : []
    ThirdParties::Pocket::Connection.new(user: @user).connected? do |on|
      on.connected { @connected_to_pocket = true }
    end

    mail(to: @user.email, subject: "Yummy ! Your Linkastor daily digest")
  end
end
