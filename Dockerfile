# ==============================
# Jupyter + WebPDF (Chromium) + LaTeX
# + OPCIONAL: kernels R, Java y C++
# ==============================
FROM continuumio/anaconda3

# --- LaTeX (opcional, útil si usas nbconvert -> pdf via LaTeX) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-latex-extra \
    texlive-plain-generic \
    build-essential g++ \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Jupyter/nbconvert al día ---
RUN pip install --no-cache-dir -U jupyter nbconvert

# --- WebPDF: renderiza Mermaid + MathJax como en el navegador ---
RUN pip install --no-cache-dir "nbconvert[webpdf]" playwright \
 && playwright install --with-deps chromium

# --- Dependencias de tu proyecto (Python) ---
ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

# ==============================
# OPCIONALES (DESCOMENTAR SEGÚN NECESIDAD)
# ==============================

# ---- R + IRkernel (notebooks en R) ----
# - Usa conda-forge para r-base e irkernel
# - Instala el kernel a nivel del sistema (--user=FALSE)
# RUN conda install -y -c conda-forge r-base r-irkernel && \
#     R -e "IRkernel::installspec(user = FALSE)"

# ---- Java + IJava (notebooks en Java) ----
# - OpenJDK 17 + kernel IJava por pip
# RUN conda install -y -c conda-forge openjdk=17 && \
#     pip install --no-cache-dir ijava && \
#     python -m ijava install --sys-prefix

# ---- C++ con xeus-cling (C++11/14/17) ----
# RUN conda install -y -c conda-forge xeus-cling && \
#     jupyter kernelspec list

# ==============================

# Puerto de Jupyter
EXPOSE 3131
CMD ["jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip=0.0.0.0", "--port=3131", "--no-browser", "--allow-root"]
