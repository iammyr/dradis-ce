class CommandsController < ProjectScopedController
  include ContentFromTemplate

  @command = Command.all

  # Rails searches the commands table and stores each row it finds in the @command instance object.
  def list
    @command = Command.all
  end

  # Rails finds only the command that has the id defined in params[:id].
  # The params object is a container that enables you to pass values between method calls.
  # For example, when you're on the page called by the list method, you can click a link for a specific command
  # and it passes the id of that command via the params object so that show can find the specific command.
  def show
    @commands = Command.find(params[:id])
  end

  # Rails knows that you will create a new object.
  # It will be called when you will display a page to the user to take user input
  def new
    @commands = Command.new
  end

  # Once the user input is taken, this method gets called to insert a record in the DB.
  def create
    # The command_params method is used to collect all the fields from object :commands.
    # The data was passed from the new method to create using the params object
    @commands = Command.new(command_params)
    # if it saved correctly to the db
    if @commands.save
      # redirect_to automatically forwards you to your destination without any user interaction (like a page refresh)
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def command_params
    params.require(:commands).permit(:user, :trackable_type, :trackable_id, :line)
  end

  # like the show method but here you can edit
  def edit
    @commands = Command.find(params[:id])
  end

  # like the create method
  def update
    @commands = Command.find(params[:id])

    if @commands.update_attributes(command_param)
      redirect_to :action => 'show', :id => :command
    else
      render :action => 'edit'
    end
  end

  def command_param
    params.require(:command).permit(:user, :trackable_type, :trackable_id, :line)
  end

  # DELETE /commands/<id>
  def destroy
    @commands.destroy
    track_destroyed(@commands)
    redirect_to summary_path
  end

  private

  def find_commands
    @this_poll  = Time.now.to_i
    @command = Command.includes(:trackable).where(
        '`user` != (?) AND `created_at` >= (?)',
        current_user.email,
        # passing the string directly doesn't work, must be a Time object:
        Time.at(params[:last_poll].to_i)
    )
  end
end
