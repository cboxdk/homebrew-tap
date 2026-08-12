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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.31.0/telemetryd-0.31.0-aarch64-apple-darwin.tar.gz"
      sha256 "b9bcae5dd7b9da8c57ceed4a1e2545a3d925739407d28e4616dff3e95d8a48a7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.31.0/telemetryd-0.31.0-x86_64-apple-darwin.tar.gz"
      sha256 "486dfccb45cb76babe67c24c46ca5575cb690cfdff06db7a8f226442a1d4a780"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.31.0/telemetryd-0.31.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b6ff02f0b288a8d4917e644062ff25aff98088a94fe27cad076f3d4ae966e543"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.31.0/telemetryd-0.31.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2362386963f7c831674a1ec37d9c49d6f25ba001691ca20ad12e040e42184c10"
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
