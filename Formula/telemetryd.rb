# Homebrew formula for telemetryd.
#
# Lives here so it is versioned with the code it installs, which is what stops the
# formula describing a version that was never built.
#
# `scripts/publish-formula.py` fills in the checksums from a published release and
# pushes the result to cboxdk/homebrew-tap. The placeholders below are deliberate: a
# formula with real-looking checksums that nobody verified is worse than one that
# obviously is not ready.
class Telemetryd < Formula
  desc "Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out"
  homepage "https://github.com/cboxdk/telemetryd"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.28.0/telemetryd-0.28.0-aarch64-apple-darwin.tar.gz"
      sha256 "cb7e8b0c9dc26ae496d48da99bede4c92a2b96286e5de3cfbdc2e05c3e6a7874"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.28.0/telemetryd-0.28.0-x86_64-apple-darwin.tar.gz"
      sha256 "901e9cbf91064b0595f847acdefc2cab786f7844a34662e83d411e6af39de0f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.28.0/telemetryd-0.28.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e3f631e59202be299acf3ec23df77fec82141a6b6ca700a65b042a2f60f34613"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.28.0/telemetryd-0.28.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "c45d0f209133a322047b25cca4eee52f783d51c6d167a477e15eea2661503439"
    end
  end

  def install
    bin.install "telemetryd"
    doc.install "README.md", "COMPATIBILITY.md", "SECURITY.md"
    (etc/"telemetryd").install "telemetryd.toml.example"
  end

  service do
    run [opt_bin/"telemetryd", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/telemetryd.log"
    error_log_path var/"log/telemetryd.log"
  end

  test do
    # `version` proves the binary runs and reports its build target; `validate` proves
    # it can resolve a complete configuration from nothing, which is the product's
    # central claim.
    assert_match version.to_s, shell_output("#{bin}/telemetryd version")
    assert_match "Configuration is valid",
      shell_output("#{bin}/telemetryd validate --data-dir #{testpath}/data")
  end
end
