class ReportsController < ApplicationController

  def create
    photo = Photo.find(params[:photo_id])
    report = current_user.reports.build(photo_id: photo.id)
    
    authorize report
    if report.save
      flash[:notice] = "\"#{photo.name}\" has been reported."
      photo.send_reported_email
    else
      flash[:error] = "Something went wrong. Please try again."
    end

    redirect_to :back
  end

  def destroy
    photo = Photo.find(params[:photo_id])
    report = Report.find(params[:id])

    authorize report
    if report.destroy
      flash[:notice] = "\"#{photo.name}\" has been unreported."
    else
      flash[:error] = "Something went wrong. Please try again."
    end

    redirect_to :back
  end
end