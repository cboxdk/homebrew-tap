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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.2/telemetryd-0.46.2-aarch64-apple-darwin.tar.gz"
      sha256 "6acbcc37746ae12fd4088854024e81f431701e63edc0ca2ad369492bdd120a7b"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.2/telemetryd-0.46.2-x86_64-apple-darwin.tar.gz"
      sha256 "6853e65fc931ca024f2b526722afca1833a97e152a88231c616c2b875df68c68"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.2/telemetryd-0.46.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "403359ecd9881ae89aefeadce99fa39757b4e16dcea0e5a84b5a0a453ea3e789"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.46.2/telemetryd-0.46.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "aff75448bd531c97b7762fc010dca63f708c8b99ad5c119223510243226a9f71"
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
