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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.3/telemetryd-0.13.3-aarch64-apple-darwin.tar.gz"
      sha256 "f544dee08546613b1d266510b78bc72ba422e4608a4a8843c26fc97c64cd78a7"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.3/telemetryd-0.13.3-x86_64-apple-darwin.tar.gz"
      sha256 "0c2237c0520cc593830fbbf6d9c7f7acd2f79909fbad2acfc9a108d20affe17a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.3/telemetryd-0.13.3-aarch64-unknown-linux-musl.tar.gz"
      sha256 "39ad9d784d829ba4f215bd76073cbf96c6bdc979da4027ff36f5e199b841e966"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.13.3/telemetryd-0.13.3-x86_64-unknown-linux-musl.tar.gz"
      sha256 "abdc204807bfeeda53b15f4f2c55ff617e355bc8d9bbf067e6748be1ab145c69"
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
