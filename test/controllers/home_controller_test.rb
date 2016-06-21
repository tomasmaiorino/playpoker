require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should return player to index" do
    get :index    
    assert_response :success
    assert_not_nil assigns(:player)
  end

  test "should return player error" do
    #post :play, :player_chosen => subcategory.id.to_s, :sort => 'title'
    post :play
    assert_response :success
    #assert_not_nil assigns(:player.errors)
    assert_nil assigns(:player_chosen)  
  end

test "should have the necessary required validators" do
  player = Player.new([], 0, 0)
  assert_not player.valid?
  assert_equal [ :players_qt, :player_chosen], player.errors.keys
end

=begin
def setup
    info = ('')
    info.stubs(:name).returns('Tomas')

    credentials = ('')
    credentials.stubs(:expires_at).returns(1456926914)
    credentials.stubs(:token).returns('CAAUxBUcWfLABAFpsc2Dj6FdLLBgcDnTT1TKgceslkuNp4BSuO4aQLgIfguvNZBzH5pAJvasdsED9shukXifvQT4voqkCC4oUYwLKPV5xHk5H2DhLYgMZCVeN4W2oYvnj9S8MTOAMO5hmNbAWZBMtTCZBqQ5EYa1fX3uamoCoLp068ELHiz7rnpBkeConLrxeZB2wk2XaDRAZDZD')

    @auth = ('')
    @auth.stubs(:provider).returns('facebook')
    #default test user has friends
    @auth.stubs(:uid).returns('100428217015609')
    @auth.stubs(:info).returns(info)
    @auth.stubs(:credentials).returns(credentials)

  end


  test "should get show with friends" do
    #setting mongo data test
    @user_friends_data_ok = '{"fc_id": "100428217015609", "data":[{"name":"Jean Grey","id":"1749693855259763"},{"name":"Professor Charles","id":"113125469077122"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    @user_id = '100428217015609'
    @mongo_connect =  MongoConnect.new
    # adding user's friend
    @mongo_connect.insert_friends(JSON.parse(@user_friends_data_ok))

    @user = User.from_omniauth(@auth)
    @request.session[:user_id] = @user.id
    get :show
    parse_friends = assigns(:friends)
    assert_not_nil parse_friends['data']
    assert_response :success
    assert_not_nil assigns(:friends)
    # removing user register in order to clean database
    @mongo_connect.delete_register_by_facebook_id(@user_id)
  end

  test "should get show with no friends" do
    @auth.stubs(:uid).returns('1532440350303095')
    @user = User.from_omniauth(@auth)
    @request.session[:user_id] = @user.id
    get :show
    parse_friends = assigns(:friends)
    assert_empty parse_friends['data']
    assert_response :success
    assert_not_nil assigns(:friends)
  end

  test "should get show with no user" do
    @request.session[:user_id] = 1
    get :show
    assert_nil assigns(:friends)
    assert_nil @request.session[:user_id]
    assert_response :success
  end
=end
end
