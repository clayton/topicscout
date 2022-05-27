class Onboarding::EmailVerificationsController < AuthenticatedUserController
  def edit
  end

  def update
    @verification = current_user.email_verifications.pending.where(id: params[:id]).first

    if @verification && @verification.code == email_verification_params[:entered_code]
      @verification.update(verified: true)
      flash[:success] = "Your email address has been verified."
      redirect_to root_path
    else
      flash[:error] = 'Sorry, that code was invalid.'
      render :edit
    end

  end

  def email_verification_params
    params.permit(:id, :entered_code)
  end
end
