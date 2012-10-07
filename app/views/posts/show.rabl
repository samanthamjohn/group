object @post

attributes :id, :title, :body, :user, :created_at, :updated_at
node :permissions do |p|
  {
    update: can?(:update, p),
    destroy: can?(:destroy, p)
  }
end
