class Batch < ApplicationRecord
	has_many :orders
	after_create :generate_reference

	private
		def generate_reference
			self.update_column(:reference, "#{created_at.strftime("%Y%m")}-#{id}")
		end
end
