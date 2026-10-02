"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";
import { cx } from "@/lib/cx";
import { Field, InputBox, useFieldControl } from "@/components/ui/Input";
import styles from "./Field.module.css";

interface RequiredDimensions {
  width: number;
  height: number;
}

interface FileFieldProps {
  label: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
  files: File[];
  onChange: (files: File[]) => void;
  multiple?: boolean;
  accept?: string;
  placeholder?: string;
  mobileHint?: string;
  maxSizeMB?: number;
  requiredDimensions?: RequiredDimensions;
}

function formatSize(bytes: number) {
  const mb = bytes / (1024 * 1024);
  return mb >= 1 ? `${mb.toFixed(1)} MB` : `${Math.max(1, Math.round(bytes / 1024))} KB`;
}

function readImageDimensions(file: File): Promise<RequiredDimensions | null> {
  if (!file.type.startsWith("image/")) return Promise.resolve(null);

  return new Promise((resolve) => {
    const url = URL.createObjectURL(file);
    const img = new window.Image();
    img.onload = () => {
      URL.revokeObjectURL(url);
      resolve({ width: img.naturalWidth, height: img.naturalHeight });
    };
    img.onerror = () => {
      URL.revokeObjectURL(url);
      resolve(null);
    };
    img.src = url;
  });
}

export function FileField({
  label,
  required,
  optional,
  error,
  files,
  onChange,
  multiple = false,
  accept = "image/*,video/*",
  placeholder,
  mobileHint,
  maxSizeMB = 10,
  requiredDimensions,
}: FileFieldProps) {
  const t = useTranslations("form.fields");
  const [localError, setLocalError] = useState<string | null>(null);
  const [checking, setChecking] = useState(false);
  const maxBytes = maxSizeMB * 1024 * 1024;

  const fileName = checking
    ? t("checkingImage")
    : files.length === 0
      ? placeholder ?? t("noFileSelected")
      : files.length === 1
        ? files[0].name
        : t("filesSelected", { count: files.length });

  async function handleFiles(list: File[]) {
    const oversized = list.filter((f) => f.size > maxBytes);
    let candidates = list.filter((f) => f.size <= maxBytes);

    const messages: string[] = [];
    if (oversized.length > 0) {
      const names = oversized.map((f) => `"${f.name}" (${formatSize(f.size)})`).join(", ");
      messages.push(
        oversized.length === 1
          ? t("fileTooLargeOne", { names, max: maxSizeMB })
          : t("fileTooLargeMany", { names, max: maxSizeMB })
      );
    }

    if (requiredDimensions && candidates.length > 0) {
      setChecking(true);
      const checked = await Promise.all(
        candidates.map(async (file) => ({ file, dims: await readImageDimensions(file) }))
      );
      setChecking(false);

      const mismatched = checked.filter(
        (c) => c.dims && (c.dims.width !== requiredDimensions.width || c.dims.height !== requiredDimensions.height)
      );
      candidates = checked.filter((c) => !mismatched.includes(c)).map((c) => c.file);

      if (mismatched.length > 0) {
        messages.push(
          mismatched.length === 1
            ? t("dimensionMismatchOne", {
                name: mismatched[0].file.name,
                width: mismatched[0].dims!.width,
                height: mismatched[0].dims!.height,
                reqWidth: requiredDimensions.width,
                reqHeight: requiredDimensions.height,
              })
            : t("dimensionMismatchMany", {
                count: mismatched.length,
                reqWidth: requiredDimensions.width,
                reqHeight: requiredDimensions.height,
              })
        );
      }
    }

    setLocalError(messages.length > 0 ? messages.join(" ") : null);

    if (candidates.length === 0) return;
    onChange(multiple ? [...files, ...candidates] : candidates);
  }

  const displayError = localError ?? error ?? undefined;
  const control = useFieldControl({ error: displayError, required });

  return (
    <Field id={control.id} label={label} required={required} optional={optional} error={displayError}>
      <InputBox
        invalid={!!displayError}
        start={
          <label htmlFor={control.id} className={cx(styles.uploadBtn, "caption-sm-medium")}>
            {t("chooseFile")}
          </label>
        }
      >
        <span
          className={cx(
            styles.uploadFileName,
            "body-sm-regular",
            (files.length === 0 || checking) && styles.uploadFileNamePlaceholder
          )}
        >
          {fileName}
        </span>
        <input
          {...control}
          type="file"
          className="sr-only"
          multiple={multiple}
          accept={accept}
          onChange={(e) => {
            const list = e.target.files ? Array.from(e.target.files) : [];
            handleFiles(list);
            e.target.value = "";
          }}
        />
      </InputBox>
      {mobileHint && <p className={cx(styles.fileHintMobile, "caption-md-regular")}>{mobileHint}</p>}
    </Field>
  );
}
