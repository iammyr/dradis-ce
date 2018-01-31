# This controller is used by the Ajax poller to retrieve changes made by other
# users.

class ActivitiesController < ProjectScopedController

  def poll
    @this_poll  = Time.now.to_i
    @activities = Activity.includes(:trackable).where(
        '`user` != (?) AND `created_at` >= (?)',
        current_user.email,
        # passing the string directly doesn't work, must be a Time object:
        Time.at(params[:last_poll].to_i)
    )

    respond_to do |format|
      format.js
    end
  end
end
