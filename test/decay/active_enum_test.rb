require "test_helper"

class ActiveEnumTest < TestCase
  class Post < ActiveRecord::Base
    extend Decay::ActiveEnum

    active_enum status: %i[draft published]
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
    skip

    post = Post.new
    post.status = :draft

    assert(post.draft?)
    refute(post.published?)
  end

  def test_set_bang
    skip

    post = Post.new

    post.draft!
    assert(post.draft?)

    post.published!
    assert(post.published?)
  end

  def test_scopes
    skip

    assert_kind_of(ActiveRecord::Relation, Post.draft)
    assert_kind_of(ActiveRecord::Relation, Post.published)
  end
end
