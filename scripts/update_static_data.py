#!/usr/bin/env python3
import json
import os
import urllib.parse
import urllib.request


class CulturaUpdater:
    def __init__(self, wikidata_queries_dir, static_data_dir, queries_files_extension):
        self.wikidata_queries_dir = wikidata_queries_dir
        self.static_data_dir = static_data_dir
        self.queries_files_extension = queries_files_extension

        self.empty_json = "{}"

    def get_files_with_queries(self):
        "return list of files (names) inside <self.wikidata_queries_dir>, ending with <self.queries_files_extension>"
        self._files_with_queries = [
            os.path.abspath(os.path.join(self.wikidata_queries_dir, filename))
            for filename in os.listdir(self.wikidata_queries_dir)
            if filename.endswith(self.queries_files_extension)
        ]
        return self._files_with_queries

    def get_raw_query_from_file(self, query_file):
        with open(query_file, "r") as f:
            return f.read()

    def encode_raw_query(self, raw_query: str):
        return urllib.parse.quote(raw_query)

    def get_json_from_wikidata(self, url_encoded_query):
        wikidata_prefix = (
            "https://query.wikidata.org/bigdata/namespace/wdq/sparql?format=json&query="
        )

        try:
            with urllib.request.urlopen(wikidata_prefix + url_encoded_query) as url:
                data = json.loads(url.read().decode())
                return data
        except urllib.error.HTTPError as e:
            # Return code error (e.g. 404, 501, ...)
            # ...
            print("HTTPError: {}".format(e.code))
        except urllib.error.URLError as e:
            # Not an HTTP-specific error (e.g. connection refused)
            # ...
            print("URLError: {}".format(e.reason))

        return self.empty_json  # get an empty json anyway

    def get_output_filename(self, query_file):
        basename = os.path.basename(query_file)
        filename, extension = os.path.splitext(basename)

        return os.path.abspath(os.path.join(self.static_data_dir, filename + ".json"))

    def save_content_to_file(self, content, path):
        with open(path, "w") as f:
            f.write(content)


if __name__ == "__main__":
    print("Starting script.")

    script_dir = os.path.dirname(os.path.realpath(__file__))
    cult = CulturaUpdater(
        wikidata_queries_dir=script_dir + "/../wikidata-queries",
        static_data_dir=script_dir + "/../static-data",
        queries_files_extension=".query",
    )

    for query_file in cult.get_files_with_queries():

        raw_query = cult.get_raw_query_from_file(query_file)
        encoded_query = cult.encode_raw_query(raw_query)

        # Fetch from WikiData
        result = cult.get_json_from_wikidata(encoded_query)

        if result != cult.empty_json:
            pretty_json = json.dumps(result, indent=4, sort_keys=True)

            output_file = cult.get_output_filename(query_file)
            cult.save_content_to_file(pretty_json, output_file)
            print("saved output to %s" % output_file)
        else:
            print("error downloading query from: %s" % query_file)
