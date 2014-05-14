# This controller is used as a baseline for all Mori Controllers
class Mori::BaseController < ApplicationController

  before_filter :mori_config, :set_token
  layout 'mori/application'

  def mori_config
    @config = Mori.configuration
  end
  def set_token
    token, user = params[:token], params[:user]
    if token or user
      @token = token || user[:token]
    end
  end
end
