#include <algorithm>
#include <cstdio>
#include <map>
#include <string>
#include <vector>

#define WIN 5
#define TOP 20

int main() {
  std::map<std::string, long> cnt[WIN + 1];
  std::vector<std::string> win;
  char line[256];
  long total = 0;

  while (fgets(line, sizeof(line), stdin)) {
    std::string rec(line);
    while (!rec.empty() && rec[rec.size() - 1] < ' ')
      rec.erase(rec.size() - 1);
    if (rec.find(" <- ") == std::string::npos)
      continue;
    total++;
    win.push_back(rec);
    if ((int)win.size() > WIN)
      win.erase(win.begin());
    std::string key;
    for (int k = 1; k <= (int)win.size(); k++) {
      key = win[win.size() - k] + (k > 1 ? " ; " + key : std::string());
      cnt[k][key]++;
    }
  }

  printf("records %ld\n", total);
  for (int k = 1; k <= WIN; k++) {
    std::vector<std::pair<long, std::string> > v;
    for (auto &it : cnt[k])
      v.push_back(std::make_pair(it.second, it.first));
    std::sort(v.rbegin(), v.rend());
    printf("\nwindow %d (%d patterns)\n", k, (int)v.size());
    for (int i = 0; i < TOP && i < (int)v.size(); i++)
      printf("%6.2f%% %10ld %s\n", 100.0 * v[i].first / (total - k + 1),
             v[i].first, v[i].second.c_str());
  }
  return 0;
}
