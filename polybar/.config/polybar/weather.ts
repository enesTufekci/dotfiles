// https://erikflowers.github.io/weather-icons/
import { exec } from "https://deno.land/x/exec/mod.ts";

const icons: Record<string, string> = {
  "01d": "",
  "01n": "",
  "02d": "",
  "02n": "",
  "03d": "",
  "03n": "",
  "04d": "",
  "04n": "",
  "09d": "",
  "09n": "",
  "10d": "",
  "10n": "",
  "11d": "",
  "11n": "",
  "13d": "",
  "13n": "",
  "50d": "",
  "50n": "",
};

const URL =
  "https://api.openweathermap.org/data/2.5/weather?q=Hamburg&appid=${process.env.WEATHER_API_ID}&units=metric";

try {
  const res = await fetch(URL);

  const { weather, main } = await res.json();

  const temp = main.feels_like;
  const { description } = weather[0];

  const RESULT = `${(temp as number).toFixed()}° ${description}`;

  exec(`echo ${RESULT}`);
} catch (_err) {
  exec(`echo ${JSON.stringify(_err)}`);
}
