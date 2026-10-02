"use client";

import type { InputHTMLAttributes } from "react";
import { Field, Input, useFieldControl } from "@/components/ui/Input";

interface TextInputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, "className" | "size"> {
  label?: string;
  required?: boolean;
  optional?: boolean;
  error?: string;
}

export function TextInput({ id, label, required, optional, error, ...rest }: TextInputProps) {
  const control = useFieldControl({ id, error, required });
  return (
    <Field id={control.id} label={label} required={required} optional={optional} error={error}>
      <Input {...control} invalid={!!error} {...rest} />
    </Field>
  );
}
