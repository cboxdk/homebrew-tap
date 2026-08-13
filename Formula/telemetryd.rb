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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.41.0/telemetryd-0.41.0-aarch64-apple-darwin.tar.gz"
      sha256 "04fffedb75d9677e2eee61eb9163eb99ba9e5d3b3715f99ba9139435fe31b08e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.41.0/telemetryd-0.41.0-x86_64-apple-darwin.tar.gz"
      sha256 "1e597ca26a89eae3ce4dbd635c7282d803377d8329bbce5ff93560884bb6ad2c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.41.0/telemetryd-0.41.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "4d4d9d01212f530c612d5e7c2b82fb252bfebb15f883e8b3e805d48199b43a3c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.41.0/telemetryd-0.41.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b82c102bdf45e3c1d8626a52550759830904eb15c8b943b84ef227c5bca8ab61"
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
