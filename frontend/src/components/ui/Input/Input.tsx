import type { ButtonHTMLAttributes, InputHTMLAttributes, Ref, SelectHTMLAttributes, TextareaHTMLAttributes } from "react";
import { cx } from "@/lib/cx";
import { Icon } from "@/components/ui/Icon";
import { InputBox, type InputBoxProps } from "./InputBox";
import styles from "./Input.module.css";

type BoxOptions = Pick<InputBoxProps, "size" | "invalid" | "start" | "end">;

interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, "size">, BoxOptions {
  ref?: Ref<HTMLInputElement>;
}

export function Input({ size, invalid, start, end, className, ...rest }: InputProps) {
  return (
    <InputBox size={size} invalid={invalid} disabled={rest.disabled} start={start} end={end}>
      <input className={cx(styles.control, "body-sm-regular", className)} {...rest} />
    </InputBox>
  );
}

interface InputActionProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  accent?: boolean;
}

export function InputAction({ accent, className, type = "button", ...rest }: InputActionProps) {
  return <button type={type} className={cx(styles.action, accent && styles.actionAccent, className)} {...rest} />;
}

interface InputButtonProps extends ButtonHTMLAttributes<HTMLButtonElement>, BoxOptions {
  empty?: boolean;
  ref?: Ref<HTMLButtonElement>;
}

export function InputButton({ size, invalid, start, end, empty, className, ...rest }: InputButtonProps) {
  return (
    <InputBox size={size} invalid={invalid} disabled={rest.disabled} start={start} end={end}>
      <button
        type="button"
        className={cx(styles.control, "body-sm-regular", empty && styles.placeholder, className)}
        {...rest}
      />
    </InputBox>
  );
}

interface TextAreaProps extends TextareaHTMLAttributes<HTMLTextAreaElement>, Pick<InputBoxProps, "invalid"> {}

export function TextAreaControl({ invalid, className, ...rest }: TextAreaProps) {
  return (
    <InputBox multiline invalid={invalid} disabled={rest.disabled}>
      <textarea className={cx(styles.control, "body-sm-regular", className)} {...rest} />
    </InputBox>
  );
}

interface SelectControlProps extends Omit<SelectHTMLAttributes<HTMLSelectElement>, "size">, BoxOptions {
  placeholder: string;
  options: { value: string; label: string }[];
}

export function SelectControl({ size, invalid, start, placeholder, options, value, className, ...rest }: SelectControlProps) {
  return (
    <InputBox
      size={size}
      invalid={invalid}
      disabled={rest.disabled}
      start={start}
    >
      <select
        value={value ?? ""}
        className={cx(styles.control, "body-sm-regular", !value && styles.placeholder, className)}
        {...rest}
      >
        <option value="" disabled>
          {placeholder}
        </option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>
      <span className={styles.selectArrow}>
        <Icon name="arrow-down" size={16} />
      </span>
    </InputBox>
  );
}
