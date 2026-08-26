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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.0/telemetryd-0.47.0-aarch64-apple-darwin.tar.gz"
      sha256 "fafb4f73b761ecaf39367617c7da0b39e4c09efcc280e5fc618d085e946e9451"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.0/telemetryd-0.47.0-x86_64-apple-darwin.tar.gz"
      sha256 "dc510adfbdd7a2c3a740ac7e19395ef15b5bb1c5eae8454fda337052cc93e23b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.0/telemetryd-0.47.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cb3dc6f96b843a1b4c4c4a082a6eee080228b104fb381ef073443071243befa3"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.47.0/telemetryd-0.47.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "9f1c5c819a0d666a0df8e468d2cbe08458f35419012853cf3979f3598175f572"
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
