class ScalaAT212 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.16/scala-2.12.16.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.16.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.16/scala-2.12.16.tgz"
  sha256 "2be383c1140e5e8dc84707fae81734f42b666766f91e55bbb04e444af8f3467f"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.12(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5b1fb55d493da7768620fc9cd88837ee878da81be629abe6444f2254423559c"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    inreplace Dir["man/man1/scala{,c}.1"], "/usr/local", HOMEBREW_PREFIX

    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala -nc #{file}").strip

    assert_equal "4", out
  end
end
