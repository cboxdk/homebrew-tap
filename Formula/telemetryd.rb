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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.70.0/telemetryd-0.70.0-aarch64-apple-darwin.tar.gz"
      sha256 "54fbae3974d1bc35c8cd59ec7cae42d0c947a291ad3f70ffb7d03f48b1b1069a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.70.0/telemetryd-0.70.0-x86_64-apple-darwin.tar.gz"
      sha256 "0f12ad3465b44b6847efed53aabe3d890f1d705773eb3eb32b68a6af9aae7a93"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.70.0/telemetryd-0.70.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "452ee3aa790af839b8b6de2f5f6d763a7ac1b47d2a9584132b4215bcc1c1bdff"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.70.0/telemetryd-0.70.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "284ec67ca5db656236e92bb03618a8fd346c6a7f6e30a136b1f594a5131ce1a6"
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
