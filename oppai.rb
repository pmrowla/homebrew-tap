# osu! pp advanced inspector (oppai) homebrew formula

class Oppai < Formula
  desc "Difficulty and pp calculator for osu! standard beatmaps."
  homepage "https://github.com/Francesco149/oppai"
  url "https://github.com/Francesco149/oppai/archive/0.9.11.tar.gz"
  sha256 "50ecded4f692918dbb3151adc6b3a1558d0429f8ad5016dc0ea79cfc63448702"
  head "https://github.com/Francesco149/oppai.git"

  depends_on "openssl"

  def install
    system "./build.sh"
    bin.install "oppai"
  end

  test do
    (testpath/"test.osu").write <<-EOS.undent
      osu file format v5

      [General]
      AudioFilename: test.mp3
      AudioLeadIn: 0
      PreviewTime: -1
      Countdown: 1
      SampleSet: Normal
      StackLeniency: 0.7
      Mode: 0
      LetterboxInBreaks: 1

      [Metadata]
      Title:Sample
      Artist:null
      Creator:null
      Version:-
      Source:
      Tags:

      [Difficulty]
      HPDrainRate:5
      CircleSize:5
      OverallDifficulty:5
      SliderMultiplier:1.4
      SliderTickRate:1

      [Events]
      3,100,163,162,255

      [TimingPoints]
      -6,500,4,1,1,100,1

      [HitObjects]
      256,192,994,1,0
    EOS
    system "#{bin}/oppai", "test.osu"
  end
end
