require "rails_helper"

describe Oauth::Authorization do
  
  #credentials=#<OmniAuth::AuthHash expires=false token="fc6c5">
  let(:credentials) { OmniAuth::AuthHash.new({expires: false, token: "fc6c663b89415...", secret: "kU8Nl4NF6nmO3..."}) }
  
  #raw_info=#<OmniAuth::AuthHash contributors_enabled=false created_at="Wed May 19 08:04:47 +0000 2010" default_profile=true default_profile_image=false description="Co-fondateur de Youboox : le streaming gratuit de livre numériques! Développeur iOS et Ruby on Rails." entities=#<OmniAuth::AuthHash description=#<OmniAuth::AuthHash urls=[]> url=#<OmniAuth::AuthHash urls=[#<OmniAuth::AuthHash display_url="youboox.fr" expanded_url="http://www.youboox.fr" indices=[0, 22] url="http://t.co/xXFVCyJHsN">]>> favourites_count=66 follow_request_sent=false followers_count=419 following=false friends_count=311 geo_enabled=false id=145560254 id_str="145560254" is_translation_enabled=false is_translator=false lang="fr" listed_count=22 location="Paris" name="vincent daubry" notifications=false profile_background_color="C0DEED" profile_background_image_url="http://abs.twimg.com/images/themes/theme1/bg.png" profile_background_image_url_https="https://abs.twimg.com/images/themes/theme1/bg.png" profile_background_tile=false profile_image_url="http://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png" profile_image_url_https="https://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png" profile_link_color="0084B4" profile_location=nil profile_sidebar_border_color="C0DEED" profile_sidebar_fill_color="DDEEF6" profile_text_color="333333" profile_use_background_image=true protected=false screen_name="vdaubry" statuses_count=1091 time_zone="Paris" url="http://t.co/xXFVCyJHsN" utc_offset=7200 verified=false>>
  let(:raw_info) { OmniAuth::AuthHash.new({contributors_enabled: false, created_at: "Wed May 19 08:04:47 +0000 2010", default_profile: true, default_profile_image: false, description: "Co-fondateur de Youboox : le streaming gratuit de livre numériques! Développeur iOS et Ruby on Rails.", favourites_count: 66, follow_request_sent: false, followers_count: 419, following: false, friends_count: 311, geo_enabled: false, id: 145560254, id_str: "145560254", is_translation_enabled: false, is_translator: false, lang: "fr", listed_count: 22, location: "Paris", name: "vincent daubry", notifications: false, profile_background_color: "C0DEED", profile_background_image_url: "http://abs.twimg.com/images/themes/theme1/bg.png", profile_background_image_url_https: "https://abs.twimg.com/images/themes/theme1/bg.png", profile_background_tile: false, profile_image_url: "http://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png", profile_image_url_https: "https://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png", profile_link_color: "0084B4", profile_location: nil, profile_sidebar_border_color: "C0DEED", profile_sidebar_fill_color: "DDEEF6", profile_text_color: "333333", profile_use_background_image: true, protected: false, screen_name: "vdaubry", statuses_count: 1091, time_zone: "Paris", url: "http://t.co/xXFVCyJHsN", utc_offset: 7200, verified: false }) }
  
  #extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash>>
  let(:extra) { OmniAuth::AuthHash.new({raw_info: raw_info}) }
  
  #info=info=#<OmniAuth::AuthHash::InfoHash description="Co-fondateur de Youboox : le streaming gratuit de livre numériques! Développeur iOS et Ruby on Rails." image="http://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png" location="Paris" name="vincent daubry" nickname="vdaubry" urls=#<OmniAuth::AuthHash Twitter="https://twitter.com/vdaubry" Website="http://t.co/xXFVCyJHsN">
  let(:info) { OmniAuth::AuthHash.new({ description: "Co-fondateur de Youboox : le streaming gratuit de livre numériques! Développeur iOS et Ruby on Rails.", image: "http://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png", location: "Paris", name: "vincent daubry", nickname: "vdaubry" })}
  
  #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash> extra=#<OmniAuth::AuthHash> info=#<OmniAuth::AuthHash::InfoHash> provider="twitter" uid="498298">
  let(:auth_hash) { OmniAuth::AuthHash.new({credentials: credentials, extra: extra, info: info, provider: "twitter", uid: "145560254"}) }
  
  describe "authorize" do
    context "new user" do
      it "creates user" do
        Oauth::Authorization.new.authorize(oauth_hash: auth_hash)
        user = User.last
        user.email.should == nil
        user.name.should == "vincent daubry"
        user.avatar.should == "http://pbs.twimg.com/profile_images/2708177483/05c946903b5db9ca741aa5552c4eaadb_normal.png"
      end
      
      it "creates authentication provider" do
        Oauth::Authorization.new.authorize(oauth_hash: auth_hash)
        authentication_provider = AuthenticationProvider.last
        authentication_provider.user.name.should == "vincent daubry"
        authentication_provider.provider.should == "twitter"
        authentication_provider.uid.should == "145560254"
        authentication_provider.token.should == "fc6c663b89415..."
      end
    end
    
    context "existing user with same authentication_provider uid" do
      before(:each) do
        @user = FactoryGirl.create(:user, name: "el vincent daubry")
        @authentication_provider = FactoryGirl.create(:authentication_provider, user: @user, token: "foo", uid: "145560254")
      end
      
      it "updates user" do
        Oauth::Authorization.new.authorize(oauth_hash: auth_hash)
        @user.reload.name.should == "vincent daubry"
      end
      
      it "updates authentication_provider" do
        Oauth::Authorization.new.authorize(oauth_hash: auth_hash)
        @authentication_provider.reload.token.should == "fc6c663b89415..."
      end
    end
  end
end