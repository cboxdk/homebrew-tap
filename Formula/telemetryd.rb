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
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.0/telemetryd-0.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "a9b7348d964fa7648459a6eb25a2c37ff3ec517981b42bbf560ea84c04981baa"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.0/telemetryd-0.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "253e4bbd72f1f9256e8dcb82f89e2e9efbfb69c9ff34c7e2228fe6ac6d15c212"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.0/telemetryd-0.15.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "436af28a265cc74e229e0a51a097ca208b6cfa49d20f6cb1ff8975a13cab3f72"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.15.0/telemetryd-0.15.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "198a246658916277f99c7000c06f07a99e41f55f730cb1c399541296330e5f2c"
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
