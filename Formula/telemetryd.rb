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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.29.0/telemetryd-0.29.0-aarch64-apple-darwin.tar.gz"
      sha256 "3dd9a8013ef35838e0a26696bc5683634d19f4079077c8ec0fea73ea5b2c3d9b"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.29.0/telemetryd-0.29.0-x86_64-apple-darwin.tar.gz"
      sha256 "60dde4d871dea55ffb542a191b1e1a866c0638717b3f4e5315513e4243a9c4f1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.29.0/telemetryd-0.29.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e6d048eab6a912e411d2a5ae54ba6a62487cf7f54cb8c67aa8a8381fdff75072"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.29.0/telemetryd-0.29.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "94afe5e11f5ccf716cdc38abeabb3d5983f4a157a2e8f89fdc59172551e40658"
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
