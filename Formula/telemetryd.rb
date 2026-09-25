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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.57.0/telemetryd-0.57.0-aarch64-apple-darwin.tar.gz"
      sha256 "1b3c63fcb8eebe3530bd19cfba2a18b8e43538eb562f03e6e68261b753e58097"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.57.0/telemetryd-0.57.0-x86_64-apple-darwin.tar.gz"
      sha256 "a3f87286157ec2b7dc003b0e9e83e733fd021f945c006fa46f44822607269df1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.57.0/telemetryd-0.57.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "e7d4db585207b69c09dc2be1d69f3938a5940a016698d5fd9e592bde653faf17"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.57.0/telemetryd-0.57.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "721794927bf8e29f0d7887c691a2fb21773e3382164d49c0c614a0c233844c4f"
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
