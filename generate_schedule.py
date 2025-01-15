import os
import datetime
from subprocess import run
from PyPDF2 import PdfMerger

# Define the LaTeX template with properly escaped curly braces
latex_template = r"""
\documentclass{{weekschedule}}

\SetupWeek{{{start_date}}}{{{end_date}}}{{Monday}}{{Sunday}}

\begin{{document}}

\PrintWeek

{daily_pages}

\end{{document}}
"""

# Generate the daily pages for the week
def generate_daily_pages(week_start):
    daily_pages = []
    for i in range(7):  # Generate daily pages for Monday to Sunday
        current_day = week_start + datetime.timedelta(days=i)
        day_name = current_day.strftime("%A")
        day_date = current_day.strftime("%m/%d/%y")
        daily_pages.append(f"\\PrintDailyPage{{{day_name}}}{{{day_date}}}")
    return "\n".join(daily_pages)

# Directory to store generated files
output_dir = "weekly_schedules"
os.makedirs(output_dir, exist_ok=True)

# Start and end dates
start_date = datetime.date(2025, 1, 13)  # January 13, 2025
end_date = datetime.date(2025, 5, 17)    # May 17, 2025

# Generate LaTeX files and compile them into PDFs
current_date = start_date
pdf_files = []

while current_date <= end_date:
    week_start = current_date
    week_end = week_start + datetime.timedelta(days=6)

    # Format dates
    week_start_str = week_start.strftime("%m/%d/%y")
    week_end_str = week_end.strftime("%m/%d/%y")

    # Generate daily pages for the week
    daily_pages = generate_daily_pages(week_start)

    # Generate LaTeX code for the week
    latex_code = latex_template.format(
        start_date=week_start_str,
        end_date=week_end_str,
        daily_pages=daily_pages
    )

    # File names
    base_name = f"week_{week_start_str.replace('/', '-')}_to_{week_end_str.replace('/', '-')}"
    tex_file = os.path.join(output_dir, f"{base_name}.tex")
    pdf_file = os.path.join(output_dir, f"{base_name}.pdf")

    # Write LaTeX code to file
    with open(tex_file, "w") as f:
        f.write(latex_code)

    # Compile LaTeX to PDF
    try:
        run(["pdflatex", "-output-directory", output_dir, tex_file], check=True)
        pdf_files.append(pdf_file)
    except Exception as e:
        print(f"Error compiling {tex_file}: {e}")

    # Move to the next week
    current_date += datetime.timedelta(days=7)

# Merge all PDFs into one
output_pdf = "combined_schedule.pdf"
merger = PdfMerger()

for pdf_file in pdf_files:
    merger.append(pdf_file)

merger.write(output_pdf)
merger.close()

print(f"Combined PDF saved as {output_pdf}")
