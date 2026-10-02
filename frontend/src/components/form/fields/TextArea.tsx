"use client";

import type { TextareaHTMLAttributes } from "react";
import { Field, TextAreaControl, useFieldControl } from "@/components/ui/Input";

interface TextAreaProps extends Omit<TextareaHTMLAttributes<HTMLTextAreaElement>, "className"> {
  label?: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
}

export function TextArea({ id, label, required, optional, error, ...rest }: TextAreaProps) {
  const control = useFieldControl({ id, error, required });
  return (
    <Field id={control.id} label={label} required={required} optional={optional} error={error}>
      <TextAreaControl {...control} invalid={!!error} {...rest} />
    </Field>
  );
}
