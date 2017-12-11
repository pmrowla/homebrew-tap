# osu! pp advanced inspector (oppai) homebrew formula

class OppaiNg < Formula
  desc "Difficulty and pp calculator for osu! standard beatmaps."
  homepage "https://github.com/Francesco149/oppai-ng"
  url "https://github.com/Francesco149/oppai-ng/archive/1.1.31.tar.gz"
  sha256 "367505d597e8b245b8b83ea677b88e53dcd0979de644eb11260810f878ca2a78"
  head "https://github.com/Francesco149/oppai-ng.git"

  conflicts_with "pmrowla/homebrew-tap/oppai", :because => "oppai-ng replaces deprecated version of oppai binary"

  def install
    system "./build"
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
