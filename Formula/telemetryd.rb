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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.52.0/telemetryd-0.52.0-aarch64-apple-darwin.tar.gz"
      sha256 "2695d74a32ec6fe6882f10ca3f1d76363a34cee38aced4bdf4d9ccc36c970aab"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.52.0/telemetryd-0.52.0-x86_64-apple-darwin.tar.gz"
      sha256 "7e3f0e607f6ca4ce5f3cf7d809e2e5b1e8c11332685ade39d92bcc7074a51f8e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.52.0/telemetryd-0.52.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "a5a932c72c647941bfa5c059662647da7682e23000ccf24795b53e05f706d5b9"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.52.0/telemetryd-0.52.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "779090759c271936946d4a55591d2b1150042e383095637c2fba6fde071923e9"
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
