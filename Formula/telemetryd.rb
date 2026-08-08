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
  version "0.11.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v#{version}/telemetryd-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "20c73693356468d7ae5274380974a0d7c7fd1ad68df037b9c1dbece4a8da1bf1"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v#{version}/telemetryd-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "ba54b170d0de75f660e3c3434dcc65614676cf521799453f745b5ce195862722"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v#{version}/telemetryd-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a23e153b51192b6f7738fef7166cd02e1ac31ba134c48cb241da255f9dad6f1c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v#{version}/telemetryd-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "7210b2e5bc99db0fd94d97e844446a8f3a48de466bdad9ae6c0e21b587ae22b4"
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
