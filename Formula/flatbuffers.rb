# flatbuffers: Build a bottle for Linuxbrew
class Flatbuffers < Formula
  desc "Serialization library for C++, supporting Java, C#, and Go"
  homepage "https://google.github.io/flatbuffers"
  url "https://github.com/google/flatbuffers/archive/v1.9.0.tar.gz"
  sha256 "5ca5491e4260cacae30f1a5786d109230db3f3a6e5a0eb45d0d0608293d247e3"
  head "https://github.com/google/flatbuffers.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "94b1585bfb800b47d1a1e00a81d3d9bff8cb8ede4fd18faaf8d7f63ff04b3767" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    def testfbs; <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

      EOS
    end
    (testpath/"test.fbs").write(testfbs)

    def testjson; <<~EOS
      {
        pos: {
          x: 1,
          y: 2,
          z: 3
        },
        hp: 80,
        name: "MyMonster"
      }
      EOS
    end
    (testpath/"test.json").write(testjson)

    system bin/"flatc", "-c", "-b", "test.fbs", "test.json"
  end
end
