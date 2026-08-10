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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.8/telemetryd-0.20.8-aarch64-apple-darwin.tar.gz"
      sha256 "c031c89afa1d53b0d5b62e4f1941f6245862385c76e077dd0560eb4d5ffdab98"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.8/telemetryd-0.20.8-x86_64-apple-darwin.tar.gz"
      sha256 "d522fc5b6d00e5687af26ede6fa71b1708a05b897dd709d2d7f713a109a20a4f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.8/telemetryd-0.20.8-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e65849307a1a4aaf81e3522e50d547435bbb8907f1be0cfd2d6ffaeeae347b4e"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.20.8/telemetryd-0.20.8-x86_64-unknown-linux-musl.tar.gz"
      sha256 "72c70cc01cd5031da5386dd46079f1122e0a1e4037bbfa722f852e5d3efa1442"
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
