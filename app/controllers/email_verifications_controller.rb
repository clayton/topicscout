class EmailVerificationsController < ApplicationController
  def edit; end

  def update
    @verification = current_user.email_verifications.pending.where(id: params[:id]).first

    if @verification && @verification.code == email_verification_params[:entered_code]
      @verification.update(verified: true)
      flash[:success] = 'Your email address has been verified.'
    else
      flash[:error] = 'Sorry, that code was invalid.'
    end

    redirect_to profile_path
  end

  def email_verification_params
    params.permit(:id, :entered_code)
  end
end
