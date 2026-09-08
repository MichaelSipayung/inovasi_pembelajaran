class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Gunakan sintaks Rails terbaru untuk enum (tambahkan titik dua sebelum role)
  enum :role, { mahasiswa: 0, dosen: 1 }
  has_many :submissions, dependent: :destroy
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :mahasiswa
  end
end
