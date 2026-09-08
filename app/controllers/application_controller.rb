class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Tambahkan baris ini agar data sidebar selalu dimuat di setiap halaman
  before_action :load_sidebar_data 

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def load_sidebar_data
    # Mengambil semua topik beserta materinya (mencegah N+1 query problem)
    @sidebar_topics = Topic.includes(:lessons).order(:created_at)
  end

  def require_dosen!
    unless current_user && current_user.dosen?
      redirect_to root_path, alert: "Akses ditolak! Halaman ini khusus untuk Dosen."
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role ])
  end
end
