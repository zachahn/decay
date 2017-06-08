require "test_helper"

class ActiveEnumTest < TestCase
  class Post < ActiveRecord::Base
    extend Decay::ActiveEnum

    active_enum status: %i[draft published]

    attribute :status, Decay::ActiveEnumAttribute.new(enum: STATUS)
  end

  def setup
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:",
    )

    ActiveRecord::Schema.define(version: 2) do
      create_table :posts do |t|
        t.string :status
      end
    end
  end

  def test_query
    post = Post.new
    post.status = :draft

    assert(post.draft?)
    refute(post.published?)
  end

  def test_set_bang
    post = Post.new

    post.draft!
    assert(post.draft?, "post should be draft")

    post.published!
    assert(post.published?, "post should be published")
  end

  def test_scopes
    assert_kind_of(ActiveRecord::Relation, Post.draft)
    assert_kind_of(ActiveRecord::Relation, Post.published)
  end

  def test_attributes
    post = Post.new
    post.status = :draft
    post.save!

    assert_kind_of(Decay::EnumeratedType, post.status)

    read_post = Post.find(post.id)

    assert_kind_of(Decay::EnumeratedType, read_post.status)
  end
end
