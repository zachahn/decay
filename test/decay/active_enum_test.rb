require "test_helper"

class ActiveEnumTest < TestCase
  class Post < ActiveRecord::Base
    extend Decay::ActiveEnum

    active_enum status: %i[draft published]

    active_enum author: { zach: "Zach Ahn" }
  end

  def setup
    ActiveRecord::Migration.verbose = false

    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ":memory:"
    )

    ActiveRecord::Schema.define(version: 2) do
      create_table :posts do |t|
        t.string :status
        t.string :author
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

  def test_correct_value_gets_saved
    post = Post.new
    post.status = :draft
    post.author = :zach
    post.save!

    result =
      ActiveRecord::Base.connection.exec_query(
        "SELECT author FROM posts"
      )

    assert_equal([{ "author" => "Zach Ahn" }], result.to_hash)

    read_post = Post.find(post.id)
    assert_equal(Post::AUTHOR[:zach], read_post.author)
  end
end
