pwm.setup(4, 512, 1023)
pwm.start(4);

function set_led_pwm(value)
  pwm.setduty(4, value);
end

return {set_led_pwm=set_led_pwm}
