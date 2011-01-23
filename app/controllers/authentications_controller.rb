class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.xml
  def index
    @authentications = current_user.authentications if current_user
  end

  # POST /authentications
  # POST /authentications.xml
  def create
    auth = request.env["omniauth.auth"]
    puts auth
    authorisation = current_user.authentications.find_or_create_by(:provider => auth['provider'], :uid => auth['uid'])
    authorisation.token = auth['credentials']['token']
    authorisation.secret = auth['credentials']['secret']
    authorisation.save
    flash[:notice] = "Authentication successful."
    redirect_to authentications_url
  end

  # PUT /authentications/1
  # PUT /authentications/1.xml
  def update
    @authentication = Authentication.find(params[:id])

    respond_to do |format|
      if @authentication.update_attributes(params[:authentication])
        format.html { redirect_to(@authentication, :notice => 'Authentication was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @authentication.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.xml
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
