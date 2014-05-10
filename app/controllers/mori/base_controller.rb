# This controller is used as a baseline for all Mori Controllers
class Mori::BaseController < ApplicationController

  before_filter :mori_config, :set_token
  layout 'mori/application'

  def mori_config
    @config = Mori.configuration
  end
  def set_token
    if params[:token] or params[:user]
      @token = params[:token] || params[:user][:token]
    end
  end
end
