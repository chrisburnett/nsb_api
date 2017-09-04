class Attachment < ApplicationRecord
  belongs_to :assignment
  mount_uploader :attachment, AttachmentUploader 
end
