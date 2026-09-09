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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.1/telemetryd-0.50.1-aarch64-apple-darwin.tar.gz"
      sha256 "557e9cc73571de9e3d72a358e38f6e61631baa211e8daac6e835c73ad963cc50"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.1/telemetryd-0.50.1-x86_64-apple-darwin.tar.gz"
      sha256 "d62889035cf09ba732767e3d01ae48f7e7b5dbaf5658cd3568eb0b0bb6056b71"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.1/telemetryd-0.50.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "74b8f914f4ececd5169fb087fc5982b9dd8aa84ba4af58d8442cae420296e711"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.1/telemetryd-0.50.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "2f63b8bb602264321f68d53191651289780f44724f2addfe4dbfbe6f1f2be56b"
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
